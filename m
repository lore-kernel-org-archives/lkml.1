Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXFMNpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXFMNpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXFMNp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:45:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:19915 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbXFMNp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:45:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oHxdDXduq89e89SAg2SFkbTyN6RaxtSJkQoGkewZbJvyN8Sir/104C/OoDqnSt0/05u94qN3q8A0j0Z4srvT7rguxT82B/AW8GbfggOoaaIEHitBJh3n6MBXlmNnhIXzsGOBYLqp001BwdzgmPajrs25kyzHlP50mT49r+sNHD0=
Message-ID: <d120d5000706130645o4b63e9e8mf7606eb682275a0@mail.gmail.com>
Date: Wed, 13 Jun 2007 09:45:27 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: Proposal: change keycode for scancode e0 32 from 150 to 172
Cc: "Hans de Goede" <j.w.r.degoede@hhs.nl>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stanislav Brabec" <sbrabec@suse.cz>,
       "Vojtech Pavlik" <vojtech@suse.cz>
In-Reply-To: <Pine.LNX.4.64.0706131131250.23280@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466F1462.5090008@hhs.nl> <466F1E5C.5090002@zytor.com>
	 <Pine.LNX.4.64.0706131113400.23280@twin.jikos.cz>
	 <466FB80E.7050902@hhs.nl>
	 <Pine.LNX.4.64.0706131131250.23280@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Wed, 13 Jun 2007, Hans de Goede wrote:
>
> > Good to hear, so as everyone smees to agree, shall I write a (massive,
> > complex, intrusive) patch to fix this, or are there until now silent
> > parties that object?
>
> Well, Dmitry is the one who has final word on this, as it is related to
> PS/2 keyboards. Just noticed he is not in CC, added.
>

Yep, just send me the patch (don't forget to make change to
drivers/char/keyboard.c that Vojtech mentioned in other e-mail).

Thanks.

-- 
Dmitry
