Return-Path: <linux-kernel-owner+w=401wt.eu-S932863AbXLNMR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbXLNMR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762882AbXLNMRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:17:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:20110 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbXLNMRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Vo7SOlr+ech038Gbv8nMjIOCq7Z9D2knK1df8jqTC7t3s3hgSbYCwc0pzbEkSug3I2jExIcbCOwSFi4UOynyyPgIUVgl6kBv72EMZO0D2eV3yNZa44Qt6UhBlljXKQJdBmuaO8GcurJ26LuquT8iBtbD49M/34DXAvIzXdw/85E=
Message-ID: <4762743F.4070605@gmail.com>
Date: Fri, 14 Dec 2007 21:17:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: ATA ACPI needs "Mr interpreter, would you please shut up?" flag
References: <47620E5E.5020001@gmail.com>
In-Reply-To: <47620E5E.5020001@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I take it back.  I found how to satisfy neurotic BIOSen.

Thanks.

-- 
tejun
