Return-Path: <linux-kernel-owner+w=401wt.eu-S1765427AbXFSCjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765427AbXFSCjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760525AbXFSCjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:39:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759895AbXFSCjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:39:31 -0400
To: david@lang.hm
Cc: Joshua David Williams <yurimxpxman.lkml@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: GPLv3 dispute solution - new open source license?
References: <200706181807.53306.yurimxpxman@gmail.com>
	<Pine.LNX.4.64.0706181541050.14890@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 23:39:23 -0300
In-Reply-To: <Pine.LNX.4.64.0706181541050.14890@asgard.lang.hm> (david@lang.hm's message of "Mon\, 18 Jun 2007 15\:43\:02 -0700 \(PDT\)")
Message-ID: <orir9k8y78.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, david@lang.hm wrote:

> On Mon, 18 Jun 2007, Joshua David Williams wrote:
>> On 6/18/07, Carlo Wood <carlo@alinoe.com> wrote:
>> 
>>> Now, writing yet another license for the linux kernel is
>>> therefore NOT the solution - if you get my drift.
>> 
>> The new license could be written to be compatible with both versions of the
>> GPL.

> no it couldn't

It could.  Just not as part of the same work.  I.e., it wouldn't be
compatible in both directions, so it wouldn't make some of the most
vocal Linux developers in that other thread happy.

But you could achieve one-way compatibility in various ways:

GPLv2+, after GPLv3 is published, and before there's a GPLv4, is
pretty much it.

One could also come up with any license that permits use under the
terms of the GPLv2 or the GPLv3.

One could also dual-license under GPLv2 and GPLv3.

FWIW, IANAL.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
