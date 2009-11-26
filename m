Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZKZLI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZKZLI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbZKZLI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:08:26 -0500
Received: from verein.lst.de ([213.95.11.210]:43841 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758915AbZKZLI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:08:26 -0500
Date: Thu, 26 Nov 2009 12:08:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: anderson@redhat.com
Cc: linux-kernel@vger.kernel.org, fedora-kernel@redhat.com
Subject: crash driver in fedora
Message-ID: <20091126110812.GA29452@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

is there a good reason the crash driver is still only stuck in the
Fedora kernel instead of beeing upstream?  We already have the
restrictive memory device options upstream, so there should be a use
case for it.
