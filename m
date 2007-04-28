Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbXD1JIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbXD1JIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXD1JIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:08:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:39612 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbXD1JIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qEBzxSBL4Pz4ZsjKyMNB+2YfkL0y4YUpZuC8N83M9xhdLEJdzKxbKdH5RxglNZV2OXQS9IrEG6lOy7oZRrkqRnjC/8nA3+qN3y2VaJaOT/VhHNpH4X5+QTKxkxd8yYysvMBbpUplzk0THFIHjyxVf8xELu4LTr8jzzXXZnZTTRM=
Message-ID: <5a04609e0704280208n5477e6d0p4386bb3a08120749@mail.gmail.com>
Date: Sat, 28 Apr 2007 12:08:42 +0300
From: "Sergey Yanovich" <ynvich@gmail.com>
To: "Alex Dubov" <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5a04609e0704280141u3676c5a5sb8bd54c3a0437bcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463242AC.5050608@gmail.com>
	 <20070428081032.1003.qmail@web36709.mail.mud.yahoo.com>
	 <5a04609e0704280141u3676c5a5sb8bd54c3a0437bcc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you successfully run this test with -mm tree? I that case
> the fault may be hardware related.

I have uploaded an updated version to bugzilla:
http://bugzilla.kernel.org/attachment.cgi?id=11308&action=view
