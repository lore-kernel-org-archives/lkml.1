Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYCJWWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYCJWWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYCJWWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:22:15 -0400
Received: from gherkin.frus.com ([192.158.254.49]:51601 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbYCJWWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:22:14 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47D58C1F.7020805@keyaccess.nl> "from Rene Herman at Mar 10, 2008
 08:29:35 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Mon, 10 Mar 2008 17:22:11 -0500 (CDT)
CC: Takashi Iwai <tiwai@suse.de>, Bob Tracy <rct@frus.com>,
       ALSA devel <alsa-devel@alsa-project.org>,
       Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080310222211.2A0BEDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Bob? How short are "short" wav files by the way?

The one I was using for testing is 50,272 bytes.  A slightly longer file
that exhibits "more exotic" looping behavior is 97,898 bytes (just a bit
over 6 seconds of audio).  I'll send you the shorter file under separate
cover.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
