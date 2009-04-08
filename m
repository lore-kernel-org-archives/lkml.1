Return-Path: <linux-kernel-owner+w=401wt.eu-S1760431AbZDHOkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431AbZDHOkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZDHOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:40:23 -0400
Received: from smtprelay05.ispgateway.de ([80.67.18.43]:58595 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZDHOkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:40:22 -0400
Message-ID: <49DCB75A.1010005@ladisch.de>
Date: Wed, 08 Apr 2009 16:40:26 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: no sound with the new imac
References: <dd18b0c30904080023r5e915af1rdbb5333d57e49188@mail.gmail.com> <200904081016.32752.rjw@sisk.pl>
In-Reply-To: <200904081016.32752.rjw@sisk.pl>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Takashi, what's the appropriate list for ALSA-related things?

alsa-devel (Takashi is on vacation until after the Easter weekend).

> On Wednesday 08 April 2009, Justin Mattock wrote:
> > Can somebody point me in the right direction
> > to creating the correct pin numbers etc...
> > for the new imac so I can have sound.

What kernel version are you using?  Are there any messages in the
system log when you load the snd-hda-intel driver?  What model do you
mean with "the new imac"?  What are the contents of
/proc/asound/card0/codec#0?


Best regards,
Clemens
