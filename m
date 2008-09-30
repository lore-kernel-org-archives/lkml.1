Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYI3C3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYI3C3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYI3C3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:29:00 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63472 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYI3C3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:29:00 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=HOhdE9u-WYN0aroMwiMA:9 a=SVMuZF8tBLfnCP-00mbXXuCTqt8A:4 a=KDuXG24fJ1wA:10 a=7n8Uyyn8sX4A:10
Message-ID: <48E18EEC.2060306@shaw.ca>
Date: Mon, 29 Sep 2008 20:29:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: gettinther <gettinther@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata dvdroms fails to be recognized by MCP55 controller with
 the 2.6.26.5 kernel
References: <fa.KIEiWFDnnp3hKXYC1evebHtUqPc@ifi.uio.no>
In-Reply-To: <fa.KIEiWFDnnp3hKXYC1evebHtUqPc@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gettinther wrote:
> Hi,
> 
> I'm currently trying to get the 2.6.26.5 kernel to work but cannot get
> the sata dvdrom to be recognized by the MCP55.  The controller works
> with the 2.6.24.4 and 2.6.25.17 kernels.  I had to use
> CONFIG_ACPI_DOCK=y for the 2.6.25.17 but this did not work with the
> 2.6.26.5.  The problem has been confirmed on at least 2 machines.
> 
> I have tried various boot options (pci=nomsi, acpi=off and any other
> relevant code I could find) but nothing seems to work.  The odd thing
> is the sata dvdrom was recognized twice by the 2.6.26.5 kernel (2
> different kernel tests) for no apparent reason (could not get it to
> work afterward).
> 
> Here's the cut info for each kernel from /var/log/messages (2.6.25.17,
> 2.6.26.5 working, 2.6.26.5 not working).  If you require further
> information I can submit it. I don't want to put too much on the first
> message.

Can you test 2.6.27-rc8?
