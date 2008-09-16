Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYIPWvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYIPWvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYIPWvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:51:47 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:49121 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751540AbYIPWvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:51:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=f/no0ALXQBF/kyNE9y/ypZx11RGVlpeoZzfPS3VDF5HgbFTRZlWPx8W/iSjO8GFqBj58k7eFEOzkXz45XT6LT3/74VAUFFN7bECm7N8ngVSybMYcU5OBxl8Ru6p/Q7Fc;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Miller <davem@davemloft.net>
Subject: Re: pci warning regression fix
Date: Tue, 16 Sep 2008 15:51:43 -0700
User-Agent: KMail/1.9.9
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
References: <20080916.154213.237157529.davem@davemloft.net>
In-Reply-To: <20080916.154213.237157529.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809161551.43856.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.246.160 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 16, 2008 3:42 pm David Miller wrote:
> Greg, please proactively push this patch of your's upstream
> as it will kill off a regression list entry:
>
> http://marc.info/?l=linux-kernel&m=121976424221858&w=4
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11439
> Subject		: [2.6.27-rc4-git4] compilation warnings
> Submitter	: Rufus &amp; Azrael <rufus-azrael@numericable.fr>
> Date		: 2008-08-26 9:37 (18 days old)
> References	: http://marc.info/?l=linux-kernel&m=121974353815440&w=4
> Handled-By	: Greg KH <gregkh@suse.de>
> Patch		: http://marc.info/?l=linux-kernel&m=121976424221858&w=4

Oops, I meant to include this in my last pull request; I'll stuff it into my 
for-linus tree now.

Thanks,
Jesse
