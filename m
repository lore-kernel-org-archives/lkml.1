Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbXFMJcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbXFMJcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 05:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbXFMJc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 05:32:28 -0400
Received: from twin.jikos.cz ([213.151.79.26]:45522 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbXFMJc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 05:32:27 -0400
Date: Wed, 13 Jun 2007 11:32:23 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stanislav Brabec <sbrabec@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Proposal: change keycode for scancode e0 32 from 150 to 172
In-Reply-To: <466FB80E.7050902@hhs.nl>
Message-ID: <Pine.LNX.4.64.0706131131250.23280@twin.jikos.cz>
References: <466F1462.5090008@hhs.nl> <466F1E5C.5090002@zytor.com>
 <Pine.LNX.4.64.0706131113400.23280@twin.jikos.cz> <466FB80E.7050902@hhs.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Hans de Goede wrote:

> Good to hear, so as everyone smees to agree, shall I write a (massive, 
> complex, intrusive) patch to fix this, or are there until now silent 
> parties that object?

Well, Dmitry is the one who has final word on this, as it is related to 
PS/2 keyboards. Just noticed he is not in CC, added.

-- 
Jiri Kosina
