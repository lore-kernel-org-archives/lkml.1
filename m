Return-Path: <linux-kernel-owner+w=401wt.eu-S1030205AbXAYPnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030205AbXAYPnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030215AbXAYPnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:43:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:51293 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030205AbXAYPnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:43:15 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: "Scott Preece" <sepreece@gmail.com>
Cc: 7eggert@gmx.de, "Pavel Machek" <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <7ELhf-4rC-9@gated-at.bofh.it> <7FKM6-7Gy-1@gated-at.bofh.it>
	<7G6ME-1g2-11@gated-at.bofh.it> <7GqrZ-6YY-1@gated-at.bofh.it>
	<7GuFj-5pj-5@gated-at.bofh.it> <7GwQL-h3-7@gated-at.bofh.it>
	<7GzF3-4L6-47@gated-at.bofh.it> <E1HA3iW-0000kF-VU@be1.lrz>
	<7b69d1470701250718l58dfbc35rd0b24e5935e32331@mail.gmail.com>
Date: Thu, 25 Jan 2007 16:43:10 +0100
In-Reply-To: <7b69d1470701250718l58dfbc35rd0b24e5935e32331@mail.gmail.com> (Scott Preece's message of "Thu\, 25 Jan 2007 09\:18\:43 -0600")
Message-ID: <878xfrglip.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Scott Preece" <sepreece@gmail.com> writes:

   On 1/25/07, Bodo Eggert <7eggert@gmx.de> wrote:
   > Imagine one computer serving two users. Two monitors, two keyboards ...
   ---

   Good point! Of late I've been working on single-user systems, so it
   was not at the front of my brain, despite years of building and using
   multi-user systems.

   It's a point that multi-user systems have struggled with forever (when
   somebody inserts a CR in the drive mounted in the system box, which user do
   you pop up a media player for?).

sed s/user X's screensaver/suspend to disk/g <<EOF

   I tend to think it's not a kernel-vs-user-space issue, though. To
   solve it you need, somewhere, a notion of a "user session" and you
   need some way to separate system-level issues (like low-battery) from
   user-level issues (like activiating user X's screensaver).

EOF

Are you sure?

best,

-- 
Experience teaches slowly and at the cost of mistakes. - James A. Froude
