Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYDBP2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYDBP2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYDBP2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:28:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45223 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755373AbYDBP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:28:35 -0400
Date: Wed, 2 Apr 2008 10:28:31 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpuset_scnprintf function
Message-Id: <20080402102831.4e29b299.pj@sgi.com>
In-Reply-To: <47F399EE.4080704@sgi.com>
References: <20080401225422.064890000@polaris-admin.engr.sgi.com>
	<20080402012006.1722c2bd.pj@sgi.com>
	<47F399EE.4080704@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
> But where is the API spec for /proc outputs?  I'd like to see how others
> have managed to change it in the past, and what are the rules for doing so.

The primary spec is the actual behaviour, unless that's clearly
busted.

Changes are usually done by adding files, lines and fields, not
changing the format of existing fields.

Perhaps you should give me a call ... I sense that the lack of
synchrony in our viewpoints is discomforting in this forum.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
