Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYJAOoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYJAOoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYJAOos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:44:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:26832 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYJAOor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LV1bHOE//9//FwDemR1ozzEmx2ph/wYwoTDoAI5oU3wVefN3Bm//eQcjOuIqX2lXhb
         aBvKikvfRA9Tf9j8m6+EDdjk0OWjdCZmZ3aCH6lruzp+WBoW39xa9L9oqf8vUPVisGNN
         99rK0NcJdTSUFjCRg+p4Djl3aCAxmM3XUU78Y=
Message-ID: <48E38CDA.4070201@gmail.com>
Date: Wed, 01 Oct 2008 16:44:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Kay Sievers <kay.sievers@vrfy.org>, Tony Vroon <tony@vroon.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: CD tray closes spontaneously after opening it
References: <200809301247.05367.elendil@planet.nl> <200809302150.38872.elendil@planet.nl> <ac3eb2510809301302l7d966896tfb0e3d230598974@mail.gmail.com> <200810011553.05318.elendil@planet.nl>
In-Reply-To: <200810011553.05318.elendil@planet.nl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2008 03:53 PM, Frans Pop wrote:
> BTW, I have considered a hardware problem like a short in the eject 
> button, but I don't think that's it.

I have the problem too, I'm following the thread. As far as I can say, HW is not
involved here. It happens after eject command too. I don't know how to reproduce
it too, though.
