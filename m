Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZKQGht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZKQGht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZKQGhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:37:48 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:41176 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZKQGhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=P+prnzSmAJ+bw7VM56GPLoi9NF0TRAp3GsJ3WdzK0nfpQh/rmTUlSBh0kHz0imNvcO
         Gbcj/nbDREI4p3qmDUvfwPWHXu2k3zSjF775h6rHjYLOrMGHtnEScHvKuwcTXQ8MUPbz
         5coSQuXcIFwtsAxarChiBxwwbcw3yXpWLGExs=
Date: Mon, 16 Nov 2009 22:37:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.32-rc7
Message-ID: <20091117063748.GA6172@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Abner Holsinger (1):
      Input: lifebook - fix settings for CF-72

Jiri Kosina (1):
      Input: psmouse - fix breakage introduced by b7802c5c1ea


Diffstat:
--------

 drivers/input/mouse/lifebook.c     |    3 +--
 drivers/input/mouse/psmouse-base.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
Dmitry

