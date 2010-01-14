Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361Ab0ANXVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0ANXVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855Ab0ANXVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:21:33 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:41941 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab0ANXVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:21:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ojGfpjdm87LQX/ULWWAyEUzlv5sQVYTTDBYhfDBNtEXP7bm3IXi8Uj2V+mXRDeGuXH
         bH+hNXsuEPPV34jdr7wEvRQ8dGhuRpStHzYqJSYfhymsNaS+Nu2NIJLK69vdrAjFc9Ye
         IXCi0P0f9hHHXrz+BLYSaqmd+HnrOVge2HQ2U=
MIME-Version: 1.0
Date: Thu, 14 Jan 2010 18:21:31 -0500
Message-ID: <b4198de61001141521t7fe8dfb9wb955f72450ca34aa@mail.gmail.com>
Subject: [PULL] alpha-2.6
From: Matt Turner <mattst88@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'for-linus' branch from my tree. It contains the
cpumask_of_node() -1 fix and adds me as a maintainer so patches don't
miss me.

Thanks,
Matt Turner

The following changes since commit 61c39bb354a1f791ba6f562b766a72e508a036ee:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git for-linus

Anton Blanchard (1):
      alpha: cpumask_of_node() should handle -1 as a node

Matt Turner (1):
      alpha: add myself as a maintainer, and drop mention of 2.4

 MAINTAINERS                       |    3 +--
 arch/alpha/include/asm/topology.h |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)
