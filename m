Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYHHAun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYHHAun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYHHAuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:50:35 -0400
Received: from outbound-mail-10.bluehost.com ([69.89.17.210]:59304 "HELO
	outbound-mail-10.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751973AbYHHAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:50:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=UfDfjQRSXeKeLUsBXPJAULvl9qRvGP4NPSQIo2fXvq9UWL8IDrV67AtKW1+lwuNfJFS7H5a6xxHMDGWKkbq765GctcYTmPf9AigUQM6Kh/M84ZT9IEi935TBVJeKYkC4;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dean Hildebrand <seattleplus@gmail.com>
Subject: Re: PCI: Limit VPD length for Broadcom 5708S
Date: Thu, 7 Aug 2008 17:50:26 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, dada1@cosmosbay.com
References: <aVL4E-5C9-7@gated-at.bofh.it> <200808070856.34679.jbarnes@virtuousgeek.org> <489B93F1.50202@gmail.com>
In-Reply-To: <489B93F1.50202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071750.26874.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 7, 2008 5:31 pm Dean Hildebrand wrote:
> BCM5706S wont work correctly unless VPD length truncated to 128
>
> Signed-off-by: Dean Hildebrand <dhildeb@us.ibm.com>

Looks like it got wrapped, but I fixed it up by hand, thanks.

Jesse
