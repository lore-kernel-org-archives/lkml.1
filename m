Return-Path: <linux-kernel-owner+w=401wt.eu-S1759159AbYGKOse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159AbYGKOse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYGKOs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:48:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbYGKOs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:48:26 -0400
Message-ID: <487772A3.5040701@linux-foundation.org>
Date: Fri, 11 Jul 2008 09:48:03 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 4/5] kmemtrace: SLUB hooks.
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>	 <1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>	 <1215712946-23572-3-git-send-email-eduard.munteanu@linux360.ro>	 <1215712946-23572-4-git-send-email-eduard.munteanu@linux360.ro>	 <20080710210617.70975aed@linux360.ro> <84144f020807110135w19cb9b5erff143912e5beb78c@mail.gmail.com>
In-Reply-To: <84144f020807110135w19cb9b5erff143912e5beb78c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
 
> Christoph, can you please take a look at this?

Yeah. I saw it. Is there some high level description as to how this is going to be used?
