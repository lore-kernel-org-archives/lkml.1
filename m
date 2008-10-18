Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYJRBPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYJRBPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 21:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYJRBPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 21:15:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:33807 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYJRBPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 21:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=HgFMAYT/erbaCQV02UWlu+uoBtMTAdAp5MZvtiVigBjvLTk+bwGsjULY+VlBcPUUg6
         3QrzcIfxJ3kD9LTV0iQ7V6kP57qUBfxujAOnMc+kGOs3jJ8Rw9o8t8jXmiJAsROHcYJS
         Wjr+rl+AoFsv74bIRdxquzJEtGg1gdEMZrK8o=
Message-ID: <f188924b0810171815rf486248s9ad1e3f968f907a1@mail.gmail.com>
Date: Sat, 18 Oct 2008 03:15:37 +0200
From: "Fred ." <eldmannen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Stop accept/merge code that does not compile without warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I read that Linus merged the GEM code.
He said about it that it was untested crap code that didn't compile
cleanly, it spitted out compiler warnings, and the code was ugly,
buggy and bad.

Kernel development is supposed to be done by professionals.
Please stop merge code that does not compile without warnings.
If when you compile it, if it does spit out warnings, then reject it!

We need professional quality, we cant merge any crap, else we get
unstable kernel with lots of bugs.
Kernel developers are supposed to be expert programmers, they
shouldn't have code that spits out warnings.
