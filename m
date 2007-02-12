Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbXBLIL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbXBLIL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 03:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbXBLIL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 03:11:28 -0500
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2673 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092AbXBLIL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 03:11:27 -0500
Message-ID: <45D0212C.4000402@xs4all.nl>
Date: Mon, 12 Feb 2007 09:11:24 +0100
From: Bauke Jan Douma <bjdouma@xs4all.nl>
Reply-To: bjdouma@xs4all.nl
Organization: a training zoo
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review II] [18/39] x86_64: Allow to run a program
 when a machine check event is detected
References: <20070212837.963446000@suse.de> <20070212073805.89FEE13D7F@wotan.suse.de> <200702120854.15814.oneukum@suse.de> <200702120904.43287.ak@suse.de>
In-Reply-To: <200702120904.43287.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote on 12-02-07 09:04:
> On Monday 12 February 2007 08:54, Oliver Neukum wrote:
>> Am Montag, 12. Februar 2007 08:38 schrieb Andi Kleen:
>>> When a machine check event is detected (including a AMD RevF threshold 
>>> overflow event) allow to run a "trigger" program. This allows user space
>>> to react to such events sooner.
>> Could this not be merged with other reporting mechanisms? This looks like
>> a new incarnation of the /etc/hotplug code.
> 
> I refuse to make mcelog depend on dbus. Just because some desktops want bloat
> doesn't mean that everybody else wants too.

Man, how I agree with that!
Refreshing to hear someone just say no.

bjd



