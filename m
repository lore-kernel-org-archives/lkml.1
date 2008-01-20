Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbYATIB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbYATIB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 03:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYATIBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 03:01:20 -0500
Received: from mail.nutech.com ([204.10.18.136]:1072 "EHLO mail.nutech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbYATIBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 03:01:18 -0500
Date: Sun, 20 Jan 2008 00:01:17 -0800
Message-Id: <200801200001.AA27066494@mail.nutech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: "mathewss" <mathewss@mail.nutech.com>
Reply-To: <mathewss@mail.nutech.com>
To: <linux-kernel@vger.kernel.org>
Subject: Re: mos7720. anyone actualy have it wokring?
X-Mailer: <IMail v8.22>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Oliver, Thanks for the reply.

 I would be glad to help.. I hope the format of this information is what you expect if not please let me know. 

Kernel messages
http://pastebin.com/f3ff758ef

Strace Log
http://pastebin.com/f87b15f6

This is the most recent mos7720.c from 
 /pub/scm/linux/kernel/git/torvalds/linux-2.6.git
But it is compiled against my 2.6.22.13-0.3 kernel if thats a problem I can run this under another kernel but it did not seem as if anything had changed that would be a problem in this kernel.

 I have a few mods I have made trying to track down whats going on mostly just some extra printk's and a fix to turn off the interrupt urb upon closing the device.

>> This driver for me does not work when i try to cat /dev/ttyUSB2
>> it fails and when i try to run
>> 
>> statserial /dev/ttyUSB2 
>> statserial: TIOCMGET failed: Invalid argument
>
>We are always looking for testers. Can you recompile with >CONFIG_USB_DEBUG,
>provide a log and do an strace of your applications?
>
>	Regards
>		Oliver
>



 Regards
  Sean Mathews

struct SoftwareProfessional {
   double salary;
   long   lunches;
   float  jobs;
   char   unstable;
   void   work;
   short  tempers;
}; 




________________________________________________________________
Sent via the WebMail system at mail.nutech.com


 
                   
