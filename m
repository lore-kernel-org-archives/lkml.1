Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbXFLLtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbXFLLtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXFLLtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:49:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40376 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbXFLLtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:49:47 -0400
Subject: Re: Allow softlockup to be runtime disabled.
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070612031354.GA18471@redhat.com>
References: <20070612031354.GA18471@redhat.com>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 13:49:45 +0200
Message-Id: <1181648985.7348.305.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 23:13 -0400, Dave Jones wrote:
> It's useful sometimes to disable the softlockup checker at boottime.
> Especially if it triggers during a distro install.

Should we not rather fix these occurrences?

