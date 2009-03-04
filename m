Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbZCDUSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbZCDUSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZCDUSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:18:10 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36314 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbZCDUSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:18:09 -0500
From: Dan Smith <danms@us.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] c/r: Add CR_COPY() macro (v3)
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
	<1236095764-19325-3-git-send-email-danms@us.ibm.com>
	<20090304140129.35e1ad97@thinkcentre.lan>
Date: Wed, 04 Mar 2009 12:18:05 -0800
In-Reply-To: <20090304140129.35e1ad97@thinkcentre.lan> (Nathan Lynch's message
	of "Wed, 4 Mar 2009 14:01:29 -0600")
Message-ID: <8763ip9h4y.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NL> Drop the semicolon ^

Thanks.

NL> You might want to employ __must_be_array() or similar to catch
NL> misuse.

Ooh, nice.

NL> Misuse might also be prevented by providing some documentation :)

Agreed.

Thanks!

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com

