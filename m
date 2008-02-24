Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbYBXXns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbYBXXns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 18:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYBXXni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 18:43:38 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:64599 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYBXXnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 18:43:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xqq/ZyDiED9BAVem6I5cvaMDdkrT46ahZZBN8aUCu3vrwaRRdYQqawIjXcCUXJ6+wjt67/xgNgeJ49kW96VfqoLmYtuN0OWL+YKURj1DSncWLJIgQiYjb5xDotP+hQKq/8ppSjLupzn9CNVA7rZTuSo+QKNd3kjIxvfwbMlkgUQ=
Message-ID: <837c0d330802241543r54250932w50a40f73eb517f53@mail.gmail.com>
Date: Mon, 25 Feb 2008 00:43:27 +0100
From: "Jasper Spaans" <jasper@vs19.net>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: lkml.org
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080224113916.e3a13389.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60802241028n1df2cd28jd98536814128b28f@mail.gmail.com>
	 <20080224113916.e3a13389.rdunlap@xenotime.net>
X-Google-Sender-Auth: 4e5b7e0bbd0a6547
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 8:39 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Sun, 24 Feb 2008 18:28:08 +0000 Adrian McMenamin wrote:
>
>  > At the risk of pointing out the obvious (though I cannot find anyone
>  > else who has commented), this appears to be broken at the moment...(ie
>  > not picking up new messages)
>  >
>  > ...which is a pity as it is a great site
>
>  Did you send email to Jasper Spaans?  (jasper at vs19.net)

Problem sort of fixed, looks like a joe job with the lkml.org domain,
causing the mta to panic because of too many incoming smtp
connections. Limits increased, all seems stable again; the archive
should be catching up now as the real mail trickles in again.


Jasper

-- 
Jasper Spaans                                       http://jasper.es/

               This line was last modified 0 seconds ago.
