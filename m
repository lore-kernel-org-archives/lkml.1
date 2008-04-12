Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYDLSjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYDLSjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbYDLSjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:39:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:37974 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbYDLSjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:39:16 -0400
Date: Sun, 13 Apr 2008 00:09:02 +0530
From: Shakul Mohideen Hameed <smohideen@blackhole.labs.rootshell.ws>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] git-clone failure over http
Message-ID: <20080412183902.GB5444@debian>
References: <c42f92750804092213p7b2c5607sa48a83086d45a825@mail.gmail.com> <47FEEDD0.4000505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FEEDD0.4000505@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 09:49:20PM -0700, H. Peter Anvin wrote:
> Shakul Mohideen Hameed wrote:
> >I am getting errors while cloning few of the kernel sources over HTTP.
> >Both proxy/direct modes are failing.
> >Please advise.
> >    - smohideen
> >
> 
> This happens when the repository maintainer hasn't done:
> 
> 	chmod +x <repo>.git/hooks/post-update
> 
> This has to be done manually for some reason.
> 
> 	-hpa

Transconnect http://transconnect.sf.net has allowed me to download the
sources through an http proxy..

 -smohideen
