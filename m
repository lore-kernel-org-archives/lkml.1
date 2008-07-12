Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYGLXIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYGLXIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYGLXI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:08:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYGLXI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:08:28 -0400
Date: Sat, 12 Jul 2008 19:06:37 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel <linux-kernel@vger.kernel.org>,
       systemtap@sourceware.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] systemtap: add parser for simple markers
Message-ID: <20080712230637.GA1976@redhat.com>
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain> <y0m1w22qxoj.fsf@ton.toronto.redhat.com> <1215697794.3353.5.camel@localhost.localdomain> <20080710142208.GC1213@redhat.com> <1215700996.3353.30.camel@localhost.localdomain> <20080710153017.GB25939@mit.edu> <1215886965.3360.16.camel@localhost.localdomain> <1215893086.3360.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215893086.3360.25.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> This is the systemtap piece that allows you to use simple markers as
> probe points for people who want to play around with the
> functionality. [...]

Clever.  We can include support for this as soon as kernel-side
simple_mark widget go upstream.

(For completeness, the code would need test cases, docs, and desirably
support for wildcarding as in probe kernel.simple_mark("*").)


- FChE
