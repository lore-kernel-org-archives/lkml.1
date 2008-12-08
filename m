Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYLHLQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYLHLQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYLHLQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:16:11 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:15187 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYLHLQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:16:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HgA7eP9+yDXvaxFvvfx1uYsEMGJMwT1vMxIQHmhLblLwRbpgzvajwIvhkEccN/gImi
         HEk9suVOZ2Fcf1Y/vlahLKa0FKP1ijyQ5sgzHIL64wItF9KRqvFdN2WsVFBImFv7dAdB
         swJQH5xq3W/zzvSdv19NuQt6o2HiNe5f1HeQI=
Message-ID: <12bfabe40812080316s56202a80v613fc35e2ff47c23@mail.gmail.com>
Date: Mon, 8 Dec 2008 12:16:08 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Andi Kleen" <ak@linux.intel.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <493D008E.8050708@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <20081207141337.588aede5@infradead.org>
	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	 <493CCFE4.2080802@jp.fujitsu.com>
	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
	 <493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>
	 <493CF65B.30408@jp.fujitsu.com>
	 <12bfabe40812080253k4154bc12he014496c027f4a85@mail.gmail.com>
	 <493D008E.8050708@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/08, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> Giangiacomo Mariotti wrote:
>> As I said in a previous post, the boot option mce=nobootlog solved the
>> problem at least from live-system point of view. About the problem at
>> rebooting/halting time(reboot enters a cycle, halt gives an mce), do
>> you have any suggestion? It seems like my bios is already the most
>> recent version available(F3). My motherboard is a Gigabyte
>> GA-EX58-UD5.
>
> It would be better to create another thread by sending new mail with
> proper subject, problem description and hardware configuration etc.
>
> Vista can handle your system well, so something bad would be in Linux.
> I guess some of ACPI folks will interested in the issue.
>
> Thanks,
> H.Seto
>
>
Ok, I'll do that then.
