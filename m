Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYFWKXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYFWKXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYFWKX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:23:28 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:47614 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYFWKX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:23:27 -0400
Message-ID: <485F79C6.20507@keyaccess.nl>
Date: Mon, 23 Jun 2008 12:24:06 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-acpi@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: LMSENSORS: 2.6.26-rc,  enabling ACPI Termal Zone support costs
 sensors
References: <485DA11C.7050906@keyaccess.nl>	<485DFF35.6080008@hhs.nl>	<485E505F.8010306@keyaccess.nl>	<485E61DE.6020202@hhs.nl> <20080623120844.5f722aa6@hyperion.delvare>
In-Reply-To: <20080623120844.5f722aa6@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.7 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-06-08 12:08, Jean Delvare wrote:

> No, the kernel does the right thing and does not need to be modified
> at all.

No Jean, this is totally unacceptable. No matter how you want to call 
things, 2.6.26 is going to break important functionality on millions of 
systems and you simply do not get to do that. Can you comment on the 
last patch posted? It's trivial:

http://lkml.org/lkml/2008/6/22/243

Rene.

