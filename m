Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925Ab0A1Vit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0A1Vit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 16:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445Ab0A1Vis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 16:38:48 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:51466 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab0A1Vir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 16:38:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=au10w/YqdS2ERT6Dcs8Xu/ayzT+ublzpXJeeKoHUtM9vCub8KqsnC633SL9GdcVG/r
         JGFSS3/FzciM1cFNgwY6oB/m713B3Y4AAnLLN693f9zf5BWiobvTcb/dy4URUnUgeG3h
         NzNE2ZImqS9x6GpoKNpPzpckO11s9tETfvaDk=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Jan 2010 13:38:27 -0800
Message-ID: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
Subject: Linux wireless GSoC 2010 project ideas
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, lsb-discuss@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Google has confirmed it will have a Google Summer of Code for 2010
[1]. Last year we had a few projects suggested (4) and accepted (3)
under the Linux Foundation sponsoring organization umbrella [2].
Unfortunately out of the three projects that were approved only one
completed successfully, that of the adding AP support to Network
Manger. I haven't seen specific updates to the progress of that but I
do know some patches were indeed submitted to help with this effort.
Perhaps the student can elaborate more.

The other projects that did not pass are up as suggestion for this
year again, but am hoping there are more. If you do have a project
idea please just go ahead and add your idea to the list of possible
projects [3]; you don't have to fill out a full page for it for now
but the more details you can add the better. If the Linux Foundation
does give us a few slots I recommend we be a little more strict about
acceptance criteria since our failure rate was pretty high (2/3) and
it would be better to see other projects get accepted if we do not
have the confidence our projects will be completed. One possibility to
help with the success rate of our projects might be to narrow the
scope down a little more. I think the testing and GeoClue project
might have been a little too ambitious and although we did have pretty
excited students we saw no progress at all.

If you have ideas for projects just feel free to add to the wiki. We
should strive to get all project ideas finalized by the middle of
February, latest the end of February. Hopefully towards the end of
February we can see who would be willing to mentor each project.
Google plans on starting to accept would-be-mentor organization
applications on  March 8th so we'll need our ideas finalized well
before that so we can send them as suggestions to the Linux Foundation
to see if we can get a few good project candidates accepted.

[1] http://groups.google.com/group/google-summer-of-code-discuss/browse_thread/thread/d839c0b02ac15b3f
[2] http://wireless.kernel.org/en/developers/GSoC/2009
[3] http://wireless.kernel.org/en/developers/GSoC/2010

  Luis
