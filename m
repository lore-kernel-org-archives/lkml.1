Return-Path: <linux-kernel-owner+w=401wt.eu-S1762887AbZAOSc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762887AbZAOSc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbZAOScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:32:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:26472 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbZAOScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ikkh3M9PvtDJtl77FEdTZMsLctBvAs4dpbXxePrHeVmUaMPjc3szZx1TuaAIfGyIex
         TQ0lMmJPGcDQOSMd+ZXU7iFe/4SZGkxGpSQ7MQV8DGYPA4nULeHsjJF/ETZ7N7mkTliA
         HsfdLc8zKSsLW9MAFmY0OhmiWeZczeNmJBeHI=
Date: Thu, 15 Jan 2009 21:32:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "harvey.harrison@gmail.com" <harvey.harrison@gmail.com>,
       "sam@ravnborg.org" <sam@ravnborg.org>,
       "jaswinderrajput@gmail.com" <jaswinderrajput@gmail.com>
Subject: Re: [patch 3/5] x86: headers cleanup - ptrace-abi.h
Message-ID: <20090115183219.GD9032@localhost>
References: <20090114203745.285473388@gmail.com>> <496e4e23.0c07560a.5e4e.529c@mx.google.com> <496E6585.8050505@zytor.com> <928CFBE8E7CB0040959E56B4EA41A77E0CD9CD33@irsmsx504.ger.corp.intel.com> <20090115084110.GB9032@localhost> <496F69C8.2040103@zytor.com> <20090115173324.GC9032@localhost> <496F788B.3090104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F788B.3090104@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Thu, Jan 15, 2009 at 09:55:23AM -0800]
... 
| The point was that if we were using #if instead of #ifdef, then -Wundef
| could be used to complain instead of silently ignoring sections.

Ah, I see now what you mean.

| 
| 	-hpa
| 
| -- 
| H. Peter Anvin, Intel Open Source Technology Center
| I work for Intel.  I don't speak on their behalf.
| 

		- Cyrill -
