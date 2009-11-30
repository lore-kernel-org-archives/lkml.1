Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZK3TtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZK3TtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZK3TtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:49:09 -0500
Received: from khc.piap.pl ([195.187.100.11]:60923 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZK3TtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:49:08 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jonsmirl@gmail.com,
       awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <BDodiKlXqgB@lirc> <4B13A161.7050405@redhat.com>
Date: Mon, 30 Nov 2009 20:49:10 +0100
In-Reply-To: <4B13A161.7050405@redhat.com> (Mauro Carvalho Chehab's message of
	"Mon, 30 Nov 2009 08:41:37 -0200")
Message-ID: <m3my23vlmx.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

>> That's a question that I have not answered for myself concludingly.
>> Is a remote control really on exactly the same level as a keyboard or  
>> mouse?
>
> On some devices like STB and TV sets (most of modern LCD/Plasma TV's
> run Linux),
> they are at the same level. I'd say that the same applies to PC's that
> the user has dedicated to work as an MCE.

A remote can just _be_ keyboard and/or (sort of) mouse.
-- 
Krzysztof Halasa
