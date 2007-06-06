Return-Path: <linux-kernel-owner+w=401wt.eu-S933715AbXFFReK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbXFFReK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbXFFRd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:33:56 -0400
Received: from mail-secure01.communicationvalley.it ([194.246.127.20]:39117
	"EHLO communicationvalley.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757423AbXFFRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:33:55 -0400
From: Silla Rizzoli <biker@ngi.it>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: No sound from Lenovo 3000 N100
Date: Wed, 6 Jun 2007 19:33:11 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200706061747.42559.biker@ngi.it> <4666DC25.9050801@redhat.com>
In-Reply-To: <4666DC25.9050801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061933.13300.biker@ngi.it>
x-pineapp-mail-mail-from: biker@ngi.it
x-pineapp-mail-rcpt-to: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 18:09, Chuck Ebbert wrote:
> On 06/06/2007 11:47 AM, Silla Rizzoli wrote:
> > I've just tried 2.6.22-rc4 and sound doesn't work. It has never worked
> > before, unless I disable ACPI.
>
> Contents of /proc/interrupts might help.

Oops, it was 2.6.21, I reverted the 2.6.22-rc3 patch without applying 
2.6.22-rc4... :P With 2.6.22-rc4 applied it finally works, however there's a 
odd bug; if I insert the headphones jack the sound keeps coming out of the 
speakers (I can also hear it from the headphones).

Best regards,
Silla Rizzoli
