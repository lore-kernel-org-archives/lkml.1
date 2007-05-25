Return-Path: <linux-kernel-owner+w=401wt.eu-S1762353AbXEYMwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762353AbXEYMwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXEYMwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:52:03 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:47126 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbXEYMwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:52:01 -0400
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from
	compressed boot wrapper
From: Ben Collins <ben.collins@ubuntu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ben Collins <bcollins@ubuntu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <p737iqxcf43.fsf@bingen.suse.de>
References: <98cd38b5.git.bcollins@ubuntu.com>
	 <b31c080.git.bcollins@ubuntu.com>  <p737iqxcf43.fsf@bingen.suse.de>
Content-Type: text/plain
Organization: Canonical
Date: Fri, 25 May 2007 08:52:23 -0400
Message-Id: <1180097543.12570.396.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 13:33 +0200, Andi Kleen wrote:
> Ben Collins <bcollins@ubuntu.com> writes:
> 
> Why? 

Because there's no other way to make the kernel totally quiet. We've
been patching this out so that the boot sequence has that "clean look".

Other than that, it's useless :)

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

