Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZBBRBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZBBRBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZBBRBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:01:10 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:30181 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZBBRBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:01:09 -0500
Date: Mon, 2 Feb 2009 10:01:07 -0700
From: Alex Chiang <achiang@hp.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, djwong@us.ibm.com,
       Trent Piepho <xyzzy@speakeasy.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: state of pci express hotplug
Message-ID: <20090202170107.GA1027@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
	djwong@us.ibm.com, Trent Piepho <xyzzy@speakeasy.org>,
	linux-kernel@vger.kernel.org
References: <m1fxj06js8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fxj06js8.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric W. Biederman <ebiederm@xmission.com>:
> 
> Trying to use the current pciehp code, on real hardware in an
> interesting topology (more later) I'm not finding it very
> satisfactory at all.  I am up to at least three show stopper
> bugs and the code is not doing what I really need it to do, so
> I am looking at a significant rewrite patch effort to make this
> code usable.

Can you send us some bug reports instead of making us just guess?

> Am I unique in thinking there is a lot that needs to be done?
> Is there current work in progress to make the pci hotplug work
> better?

I think we all want to help, but that's hard if we don't know
what's broken on your machine.

Thanks.

/ac

