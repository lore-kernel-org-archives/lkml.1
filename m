Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154Ab0AAQ6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab0AAQ6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 11:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054Ab0AAQ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 11:58:05 -0500
Received: from isilmar.linta.de ([213.133.102.198]:40721 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023Ab0AAQ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 11:58:03 -0500
Date: Fri, 1 Jan 2010 17:51:04 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Greg Banks <gnb@sgi.com>, Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: dynamic debug during boot / module insert?
Message-ID: <20100101165104.GA9062@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Greg Banks <gnb@sgi.com>, Jason Baron <jbaron@redhat.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

is there any boot option / other tweak to enable some dynamic debug calls
early on, even before userspace / debugfs is up and available? Also, is
there a chance to enable dynamic debug calls for a module just to be loaded
/ initialized?

Best,
	Dominik
