Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbXKDXVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbXKDXVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbXKDXVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:21:18 -0500
Received: from gw.goop.org ([64.81.55.164]:39750 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbXKDXVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:21:17 -0500
Message-ID: <472E53D0.2000204@goop.org>
Date: Sun, 04 Nov 2007 15:20:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Marco Costalba <mcostalba@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: duplicated include files
References: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com> <e5bfff550711041143i7be3cff7kd4903ed43cb4e232@mail.gmail.com> <Pine.LNX.4.64.0711041447330.6072@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0711041447330.6072@localhost.localdomain>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> actually, one wonders if there's any value in keeping any references
> to other version control systems such as subversion, SCCS, CVS,
> mercurial, etc.
>   

What do you mean by "other"?  git doesn't have a monopoly, and the
kernel should support people using a reasonable set of version control
systems.  Supporting VSS would be strange, but nothing wrong with the
set you listed, if people find those systems useful.  It's not like it
amounts to a huge amount of effort to do so.

    J
