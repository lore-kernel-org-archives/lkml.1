Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZCCSEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZCCSEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZCCSEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:04:36 -0500
Received: from verein.lst.de ([213.95.11.210]:48060 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbZCCSEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:04:36 -0500
Date: Tue, 3 Mar 2009 19:04:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Future of md multipath
Message-ID: <20090303180433.GA27569@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just noticed that we still have the old md-based multipath driver
in the tree, which seem to not have gotten any attention since we
got dm multipath.

Is there any reason to keep it or should we deprecate it and kill
it after a couple of kernel releases?
