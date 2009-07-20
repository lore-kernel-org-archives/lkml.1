Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZGTTum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZGTTum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZGTTul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:50:41 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:52146 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZGTTuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=S2CozsA0oIzXFz6w/v6w1zVaFRlhZHaJAMf8VJv682tLsCWG/H/RhFdgo3rMITW8Jw
         +UHzXyEcpUWNRjZexgzVwz/1T7UlCLxWCmHMBInNOeDk+TqFGuvD8FwoKPBFvIKlYQMM
         hJ8UGnmQrQ73ugrtDwcvUtMsNHwldN9DScKHY=
Date: Mon, 20 Jul 2009 21:50:32 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Damien Wyart <damien.wyart@free.fr>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720215032.476c54b5@varda>
In-Reply-To: <20090720194229.GB29819@suse.de>
References: <20090720040813.GC11940@kroah.com>
	<200907201613.22483.wolfgang.walter@stwm.de>
	<20090720150916.GB10015@suse.de>
	<20090720180333.GA2905@brouette>
	<20090720212318.2aa5be21@varda>
	<20090720194229.GB29819@suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 20 Jul 2009 12:42:29 -0700
Greg KH <gregkh@suse.de> escribió:


> 
> What revert do you find needed?

 Full story here: 
http://bugzilla.kernel.org/show_bug.cgi?id=13362

 i'm reverting 7e0986c17f695952ce5d61ed793ce048ba90a661 for my own
use. The mail threath with Ivo seems to indicate that my hardware 
is weird so i do not think the problem will be resolved anytime soon
People lost interest i guess


> thanks,
> 
> greg k-h
