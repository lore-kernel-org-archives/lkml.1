Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZLKJVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZLKJVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbZLKJVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:21:03 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41784 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbZLKJVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:21:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gil860oEoWTq8penW1iUXP1YgbpAs1yAVqebFJMuqetE6OWOWeYQfE9k4J4P3ZcwB7
         h9mvN1gf4eTsDrGLx5WLUoVwQsKIMYJyo9yNIYJFUJhdfRWx6SDFWop7uf2j/WnVIkcZ
         AazZ4xj9/myHeTL3ug/l15Q5Qi1TypaK5oJg0=
MIME-Version: 1.0
Date: Fri, 11 Dec 2009 10:21:06 +0100
Message-ID: <ffd8902a0912110121k795223ar6af644c41cd357b8@mail.gmail.com>
Subject: Q: Why I do have to restart alsa everytime after a resume from 
	disk/ram ? Is this alsa- or kernel or config related??
From: Christian Hartmann <cornogle@googlemail.com>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello list,

everytime I suspended to disk or to ram, regardless of the used kernel
(git or stable from distri), I must restart alsa to hear sound again.
searched google and tried a lot but still the same awful behaviour.
Has anybode some suggestions for me? is this alsa related ? or is this
a kernel issue which could be dealt here?

If any logs/debugs/regs are needed, pls ask me.

Any help would be appreciated


sincerely yours
Chris H.
-- 
......oooO..............
.....(....).....Oooo...
......)../.....(....)....
.....(_/.......)../.....
...............(_/.......
... I WAS ..............
.......... HERE...... ;)
