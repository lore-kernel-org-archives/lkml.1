Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZBOOms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZBOOms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZBOOmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:42:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:42884 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZBOOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=u1VZPtSS3PVC9zdGAkDG5iXXh7jSQxhyWyIlbAzz/zncqFspFI7QMyMMeZEKO/Z4Lt
         TLG8Rws0T4YJ/crppRUZIkQtkvU5EoTBXtT5XLEdG03irm6d/O3Zfi9CJrToQRQN2ggh
         mXHBTq4g7PnPPJ43zaJsXBmh/nEoieCHC4hSk=
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ira Snyder" <iws@ovro.caltech.edu>
Subject: Re: [Bug #12615] boot hangs while bringing up gianfar ethernet
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
	<rjPbZ5GRJPO.A.__E.7r0lJB@chimera>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Sun, 15 Feb 2009 15:42:34 +0100
In-Reply-To: <rjPbZ5GRJPO.A.__E.7r0lJB@chimera> (Rafael J. Wysocki's message of "Sat\, 14 Feb 2009 21\:38\:19 +0100 \(CET\)")
Message-ID: <8763jbep7p.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Rafael" == Rafael J Wysocki <rjw@sisk.pl> writes:

 Rafael> This message has been generated automatically as a part of a report
 Rafael> of recent regressions.

 Rafael> The following bug entry is on the current list of known
 Rafael> regressions from 2.6.28.  Please verify if it still should be
 Rafael> listed and let me know (either way).

As already mentioned, the fix works for me so I think this can be
closed.

 Rafael> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12615
 Rafael> Subject		: boot hangs while bringing up gianfar ethernet
 Rafael> Submitter	: Ira Snyder <iws@ovro.caltech.edu>
 Rafael> Date		: 2009-01-29 19:41 (17 days old)
 Rafael> References	: http://marc.info/?l=linux-kernel&m=123325817201665&w=4

-- 
Bye, Peter Korsgaard
