Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYGXRal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYGXRal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYGXRac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:30:32 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:51828 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751117AbYGXRac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:30:32 -0400
Date: Thu, 24 Jul 2008 13:30:30 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: linux-kernel@vger.kernel.org
Subject: merging branches remotely with git?
Message-ID: <20080724173030.GA7609@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    I am trying to do a local merge of the linus-kernel git and
the my-wireless-testing git. Is this possible? I have cloned both
locally with...

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
git clone git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git

I thought from the git documentation that I was supposed to be able to
create a merge automatically with...

git merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git

however this reports...

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git - not something we can merge

Any advice on how this can be done would be appreciated.
                  Jack
