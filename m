Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288Ab0ABCWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab0ABCWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 21:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196Ab0ABCWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 21:22:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:58163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab0ABCWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 21:22:31 -0500
Message-ID: <4B3EAE33.4060009@kernel.org>
Date: Sat, 02 Jan 2010 11:23:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, x86@kernel.org
Subject: Re: 2.6.32 regression: unable to handle kernel paging request
References: <4B269765.1070703@klingt.org> <4B2A2A7D.1050506@klingt.org> <4B2A93F2.3070407@klingt.org> <4B2AFBB1.3040609@kernel.org> <4B2B4838.6080509@klingt.org> <4B2F20E0.30804@kernel.org> <4B2F40C0.5020407@klingt.org> <4B33592B.6000107@kernel.org> <4B335964.6040202@klingt.org> <4B335DE6.9030102@kernel.org> <4B336303.2090403@kernel.org> <4B372E02.9050509@klingt.org> <4B3E6155.5080005@klingt.org>
In-Reply-To: <4B3E6155.5080005@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/02/2010 05:55 AM, Tim Blechmann wrote:
> trying to boot the current linus/master branch, i saw a similar issue as
> before, but with binutils 2.20

Given that the ldscript modification has been out in the wild for some
time and you are the only one reporting this type of problem, I don't
think it's likely to be a widespread problem.  Can you please try it
from a clean installation just in case?

Thanks.

-- 
tejun
