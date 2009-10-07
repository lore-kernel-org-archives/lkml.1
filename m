Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZJGXmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZJGXmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZJGXmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:42:12 -0400
Received: from lo.gmane.org ([80.91.229.12]:35594 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbZJGXmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:42:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jack Byer <ojbyer@usa.net>
Subject: Re: iso9660 mount problem
Followup-To: gmane.linux.kernel
Date: Wed, 07 Oct 2009 18:42:52 -0500
Message-ID: <haj8uj$fn8$2@ger.gmane.org>
References: <haj471$fn8$1@ger.gmane.org> <58965d8a0910071618s2420fed1k4ccde4823e57f756@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp-70-242-115-61.dsl.rcsntx.swbell.net
User-Agent: KNode/4.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Hartman wrote:

> On Wed, Oct 7, 2009 at 5:22 PM, Jack Byer <ojbyer@usa.net> wrote:
>> I have a CD of a commercial software program that I am attempting to run
>> under wine. The CD works without problems under Windows, but when I mount
>> it on linux the file system appears to be empty (no files or
>> directories). The drive is capable of reading the CD because "strings
>> /dev/cdrom" works.
>>
>> What would I need to do in order to troubleshoot this problem?
> 
> Maybe try mounting with the "-o unhide" option. Or maybe it is a
> multi-session disc?

-o unhide does not help. Can a factory-pressed disc be multisession? It's 
not a CD-R

