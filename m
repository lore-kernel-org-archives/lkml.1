Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYBAIJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYBAIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYBAIJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:09:15 -0500
Received: from ns.suse.de ([195.135.220.2]:36621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYBAIJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:09:14 -0500
From: Frank Seidel <fseidel@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v2 0/3] nozomi: driver updates to current git tree
Date: Fri, 1 Feb 2008 09:09:11 +0100
User-Agent: KMail/1.9.5
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
References: <200801312210.30722.fseidel@suse.de> <20080201072815.GA5345@uranus.ravnborg.org> <200802010859.14583.fseidel@suse.de>
In-Reply-To: <200802010859.14583.fseidel@suse.de>
Organization: SuSE Linux Products GmbH
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802010909.11634.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanups and constification of nozomi driver

Mostly trivial cleanups and updates and constification
and annotations of vars.
Patches are based on current linus git tree (while
[PATCH v2 1/3] is already in Gregs gregkh-2.6 tree).

Signed-off-by: Frank Seidel <fseidel@suse.de>

 nozomi.c |  174 ++++++++++++++++++++++-----------------------------------------
 1 file changed, 61 insertions(+), 113 deletions(-)
