Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbXCMQGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbXCMQGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXCMQGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:06:34 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:34126 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbXCMQGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:06:33 -0400
Date: Tue, 13 Mar 2007 17:06:32 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Balbir Singh <balbir@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Emelianov <xemul@sw.ru>,
       Kirill@osdl.org, Linux@osdl.org, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-ID: <20070313160632.GP8755@MAIL.13thfloor.at>
Mail-Followup-To: Balbir Singh <balbir@in.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Emelianov <xemul@sw.ru>, Kirill@osdl.org, Linux@osdl.org,
	containers@lists.osdl.org, Paul Menage <menage@google.com>,
	List <linux-kernel@vger.kernel.org>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org> <20070309164855.GB3647@MAIL.13thfloor.at> <661de9470703120255k4c4c1d0fy97a2b7a033c7b5b1@mail.gmail.com> <20070312234335.GA11578@MAIL.13thfloor.at> <661de9470703121857pc695e3cp2c3c853be3622689@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <661de9470703121857pc695e3cp2c3c853be3622689@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 07:27:06AM +0530, Balbir Singh wrote:
> > hmm, it is very unlikely that this would happen,
> > for several reasons ... and indeed, checking the
> > thread in my mailbox shows that akpm dropped you ...
> 
> But, I got Andrew's email.
> 
> > --------------------------------------------------------------------
> > Subject: [RFC][PATCH 2/7] RSS controller core
> > From: Pavel Emelianov <xemul@sw.ru>
> > To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
> >         Srivatsa Vaddagiri <vatsa@in.ibm.com>,
> >         Balbir Singh <balbir@in.ibm.com>
> > Cc: containers@lists.osdl.org,
> >         Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > Date: Tue, 06 Mar 2007 17:55:29 +0300
> > --------------------------------------------------------------------
> > Subject: Re: [RFC][PATCH 2/7] RSS controller core
> > From: Andrew Morton <akpm@linux-foundation.org>
> > To: Pavel Emelianov <xemul@sw.ru>
> > Cc: Kirill@smtp.osdl.org, Linux@smtp.osdl.org, containers@lists.osdl.org,
> >         Paul Menage <menage@google.com>,
> >         List <linux-kernel@vger.kernel.org>
> > Date: Tue, 6 Mar 2007 14:00:36 -0800
> > --------------------------------------------------------------------
> > that's the one I 'group' replied to ...
> >
> > > Could you please not modify the "cc" list.
> >
> > I never modify the cc unless explicitely asked
> > to do so. I wish others would have it that way
> > too :)
> 
> Thats good to know, but my mailer shows
> 
> 
> Andrew Morton <akpm@linux-foundation.org>
> 	to		Pavel Emelianov <xemul@sw.ru>	
> 	cc	
> 	Paul Menage <menage@google.com>,
> Srivatsa Vaddagiri <vatsa@in.ibm.com>,
> Balbir Singh <balbir@in.ibm.com> (see I am <<HERE>>),
> devel@openvz.org,
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
> containers@lists.osdl.org,
> Kirill Korotaev <dev@sw.ru>	
> 	date		Mar 7, 2007 3:30 AM	
> 	subject		Re: [RFC][PATCH 2/7] RSS controller core	
> 	mailed-by		vger.kernel.org	
> On Tue, 06 Mar 2007 17:55:29 +0300
> 
> and your reply as
> 
> Andrew Morton <akpm@linux-foundation.org>,
> Pavel Emelianov <xemul@sw.ru>,
> Kirill@smtp.osdl.org,
> Linux@smtp.osdl.org,
> containers@lists.osdl.org,
> Paul Menage <menage@google.com>,
> List <linux-kernel@vger.kernel.org>	
> 	to		Andrew Morton <akpm@linux-foundation.org>	
> 	cc	
> 	Pavel Emelianov <xemul@sw.ru>,
> Kirill@smtp.osdl.org,
> Linux@smtp.osdl.org,
> containers@lists.osdl.org,
> Paul Menage <menage@google.com>,
> List <linux-kernel@vger.kernel.org>	
> 	date		Mar 9, 2007 10:18 PM	
> 	subject		Re: [RFC][PATCH 2/7] RSS controller core	
> 	mailed-by		vger.kernel.org
> 
> I am not sure what went wrong. Could you please check your mail
> client, cause it seemed to even change email address to smtp.osdl.org
> which bounced back when I wrote to you earlier.

my mail client is not involved in receiving the emails,
so the email I replied to did already miss you in the cc
(i.e. I doubt that mutt would hide you from the cc, if
it would be present in the mailbox :)

maybe one of the mailing lists is removing receipients
according to some strange scheme?

here are the full headers for the email I replied to:

-8<------------------------------------------------------------------------
>From containers-bounces@lists.osdl.org  Tue Mar  6 23:01:21 2007
Return-Path: containers-bounces@lists.osdl.org
X-Original-To: herbert@13thfloor.at
Delivered-To: herbert@13thfloor.at
Received: from smtp.osdl.org (smtp.osdl.org [65.172.181.24])
       	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
       	(No client certificate requested)
       	by mail.13thfloor.at (Postfix) with ESMTP id 0CD0F707FC
       	for <herbert@13thfloor.at>; Tue,  6 Mar 2007 23:00:52 +0100 (CET)
Received: from fire-2.osdl.org (localhost [127.0.0.1])
       	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l26M0eqA023167;
       	Tue, 6 Mar 2007 14:00:47 -0800
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
       	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l26M0bq8023159
       	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO);
       	Tue, 6 Mar 2007 14:00:37 -0800
Received: from akpm.corp.google.com (shell0.pdx.osdl.net [10.9.0.31])
       	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id l26M0ate010730;
       	Tue, 6 Mar 2007 14:00:36 -0800
Date: Tue, 6 Mar 2007 14:00:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@sw.ru>
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-Id: <20070306140036.4e85bd2f.akpm@linux-foundation.org>
In-Reply-To: <45ED80E1.7030406@sw.ru>
References: <45ED7DEC.7010403@sw.ru>
       	<45ED80E1.7030406@sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
X-Spam-Status: No, hits=-1.453 required=5
+tests=AWL,OSDL_HEADER_LISTID_KNOWN,OSDL_HEADER_SUBJECT_BRACKETED
X-Spam-Checker-Version: SpamAssassin 2.63-osdl_revision__1.119__
X-MIMEDefang-Filter: osdl$Revision: 1.176 $
Cc: Kirill@smtp.osdl.org, Linux@smtp.osdl.org, containers@lists.osdl.org,
       	Paul Menage <menage@google.com>,
       	List <linux-kernel@vger.kernel.org>
X-BeenThere: containers@lists.osdl.org
X-Mailman-Version: 2.1.8
Precedence: list
List-Id: Linux Containers <containers.lists.osdl.org>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/containers>,
       	<mailto:containers-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/containers>
List-Post: <mailto:containers@lists.osdl.org>
List-Help: <mailto:containers-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/containers>,
       	<mailto:containers-request@lists.osdl.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: containers-bounces@lists.osdl.org
Errors-To: containers-bounces@lists.osdl.org
Received-SPF: pass (localhost is always allowed.)
Status: RO
X-Status: A
Content-Length: 854
Lines: 27

-8<------------------------------------------------------------------------

> > best,
> > Herbert
> >
> 
> Cheers,
> Balbir
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
