Return-Path: <linux-kernel-owner+w=401wt.eu-S1762340AbXJOKhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762340AbXJOKhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 06:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXJOKg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 06:36:58 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:52615 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXJOKg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 06:36:57 -0400
Message-ID: <471342C8.2030305@free.fr>
Date: Mon, 15 Oct 2007 12:36:56 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr> <470F4535.3050004@free.fr> <470F4F58.4080900@gmail.com> <470F7264.8070205@free.fr>
In-Reply-To: <470F7264.8070205@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> Alexey Starikovskiy wrote:
> 
>> Could you please open bug at bugzilla.kernel.org and put all these
>> files there?
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9148

Writing 15361 (i.e. 0x3C01) to ACPI_REGISTER_PM1A_CONTROL appears to 
hang my system in acpi_os_write_port(). What can I do about that?

Is it a BIOS issue? a kernel issue? a hardware issue?

(All my results are attached to the bug report.)

Regards.
