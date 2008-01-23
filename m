Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbYAWTip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbYAWTip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYAWTii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:38:38 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:44937 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYAWTih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:38:37 -0500
Subject: Re: [RFC] Userspace tracing memory mappings
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: mbligh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080123160454.GA15405@Krystal>
References: <20080123160454.GA15405@Krystal>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 11:38:32 -0800
Message-Id: <1201117112.8329.9.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-23 at 11:04 -0500, Mathieu Desnoyers wrote:
> Since memory management is not my speciality, I would like to know if
> there are some implementation details I should be aware of for my
> LTTng userspace tracing buffers. Here is what I want to do :

Can you start with a little background by telling us what a userspace
tracing buffer _is_?  Maybe a few requirements about what you need it to
do and why, as well?

-- Dave

