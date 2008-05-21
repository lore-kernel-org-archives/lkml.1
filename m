Return-Path: <linux-kernel-owner+w=401wt.eu-S934554AbYEUWP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554AbYEUWP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYEUWPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:15:47 -0400
Received: from saeurebad.de ([85.214.36.134]:47951 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbYEUWPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:15:47 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Philipp Marek <philipp@marek.priv.at>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [patch] kmalloc returns (void*), don't do type conversions
References: <200805212113.51936@marek.priv.at> <877idn4dk1.fsf@saeurebad.de>
Date: Thu, 22 May 2008 00:15:20 +0200
In-Reply-To: <877idn4dk1.fsf@saeurebad.de> (Johannes Weiner's message of "Wed,
	21 May 2008 22:17:34 +0200")
Message-ID: <87y7632tjb.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@saeurebad.de> writes:

> Added the trivial tree maintainer to CC.  Jesper?

Sorry, it's trivial@kernel.org.
