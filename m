Return-Path: <linux-kernel-owner+w=401wt.eu-S965681AbXIGNP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965681AbXIGNP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 09:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965352AbXIGNPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 09:15:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:31905 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345AbXIGNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 09:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MRXzy6WxwACKqC3g3jg4MifSXSG5526M4MZQHyi7rJba98zcQRxAwEYZjUGBaLSs3uDpVEHMPt0iRRKjfPPbm+BzsU+tw3KSCdK2r/YFdDjI9bn4QBAyRCnPbBzmw9IW8xRGjDZsTC34JBF1pgHY0UVUiz2xZWQpRzCvnUvGcE0=
Message-ID: <3d8471ca0709070615o5627161ard506fa8b89b1566e@mail.gmail.com>
Date: Fri, 7 Sep 2007 15:15:16 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: EIP: [<c02d0069>] tcp_rto_min+0x8/0x12 SS:ESP 0068:c03bbd6c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BAY103-DAV19AEEDC8DA30835B958052B2C50@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BAY103-DAV19AEEDC8DA30835B958052B2C50@phx.gbl>
X-Google-Sender-Auth: 1bb7bdab0afc6a66
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/7, Marco Berizzi <pupilla@hotmail.com>:
> Hello.
> Linux 2.6.23-rc5 after 30 minutes crash with this
> error message (taken from serial console):

Hi, this should be fixed in mainline by
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5c127c58ae9bf196d787815b1bd6b0aec5aee816

Also, network problems should be reported to netdev@vger.kernel.org

Hope this helps.

-- 
Guillaume
