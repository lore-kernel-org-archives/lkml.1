Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbYBOS2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbYBOS2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYBOS1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:27:52 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:47124 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbYBOS1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:27:52 -0500
Date: Fri, 15 Feb 2008 19:27:50 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make sysctl a separate filesystem
In-Reply-To: <6101e8c40802150857h656efbf9of2646e9ae8c07a5b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802151818370.30301@fbirervta.pbzchgretzou.qr>
References: <47B56BF2.4020600@openvz.org> <p73ejbe1ook.fsf@bingen.suse.de> 
 <18357.30971.334517.722985@harpo.it.uu.se> 
 <Pine.LNX.4.64.0802151343330.30301@fbirervta.pbzchgretzou.qr>
 <6101e8c40802150857h656efbf9of2646e9ae8c07a5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15 2008 17:57, Oliver Pinter wrote:
>> >
>> >Doing it automatically is the only acceptable way, IMO.
>>
>> For time being only.
>>
>> The kernel (currently) only auto-mounts invisible filesystems.
> and /selinux with selinuxfs, it is automounted ... but it is visible fs
>
Sorry if I do not know all the exceptional exceptions.
