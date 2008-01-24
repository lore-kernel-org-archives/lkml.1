Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbYAXWEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbYAXWEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbYAXWEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:04:33 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:37601 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbYAXWEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:04:31 -0500
Date: Thu, 24 Jan 2008 14:04:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: Preparing for merge window
Message-Id: <20080124140422.409555b9.randy.dunlap@oracle.com>
In-Reply-To: <20080124215813.GA4204@uranus.ravnborg.org>
References: <20080124215813.GA4204@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008 22:58:13 +0100 Sam Ravnborg wrote:

> The following is the list of patches queued up for the merge window at the moment.
> I have during the last week done several modpost changes to make section ismatch
> warnings more reliable and I am happy with the modified modpost code now.


Hi Sam,

Can you add (if not already done) a paragraph to kconfig-language.txt
about the preference of using HAVE_feature in Kconfig files vs.
other spellings of that?

---
~Randy
