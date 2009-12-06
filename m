Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZLFUWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZLFUWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbZLFUWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:22:11 -0500
Received: from khc.piap.pl ([195.187.100.11]:40866 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566AbZLFUWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:22:10 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
       dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	<BENh5lRHqgB@lirc>
	<9e4733910912060838j29f107cpd827e2d7b8a20c1c@mail.gmail.com>
Date: Sun, 06 Dec 2009 21:22:13 +0100
In-Reply-To: <9e4733910912060838j29f107cpd827e2d7b8a20c1c@mail.gmail.com> (Jon
	Smirl's message of "Sun, 6 Dec 2009 11:38:55 -0500")
Message-ID: <m3ws0z6efe.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl <jonsmirl@gmail.com> writes:

> The in-kernel support can start small and add protocols and maps over
> time.

Protocols, yes. Maps - we certainly don't want megatons of maps in the
kernel. The existing ones have to be removed, some time.
-- 
Krzysztof Halasa
