Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbZDBTBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbZDBTBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZDBTB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:01:27 -0400
Received: from blaine.gmane.org ([80.91.229.8]:35076 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbZDBTB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=N9o0THjFeU6Zs6raLmdI+dtImMJA/kLH+T3MDTsEbI3PO5oWICKWS16t8p5VtAbulD
         gGyoPeL04WMhUXQXT46oDIR6/dIe+8Oy8hO1XJ9NiF4eBS6YrFOlgQ/8DZ+Jbml1Wh2v
         fqs8Pv6SutPb7k1PMpcFak4vZNBaHKOIzVmHo=
MIME-Version: 1.0
In-Reply-To: <1526.1238664007@redhat.com>
References: <alpine.LFD.2.00.0904010935000.4130@localhost.localdomain>
	 <1238522824.6577.5.camel@heimdal.trondhjem.org>
	 <19756.1238606665@redhat.com> <buoprfv8yjf.fsf@dhlpc061.dev.necel.com>
	 <1526.1238664007@redhat.com>
Date: Fri, 3 Apr 2009 03:56:09 +0900
X-Google-Sender-Auth: de1cc362ba152dba
Message-ID: <fc339e4a0904021156ke84b45elc55d07acea795c99@mail.gmail.com>
Subject: Re: [GIT PULL] Please pull the first batch of NFS client changes (and 
	cachefs merge)...
From: Miles Bader <miles@gnu.org>
To: David Howells <dhowells@redhat.com>
Cc: David Howells 
	<public-dhowells-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>,
       Linus Torvalds 
	<public-torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@hugh.gmane.org>,
       Trond Myklebust 
	<public-Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@hugh.gmane.org>,
       public-linux-nfs-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2009/4/2 David Howells <dhowells@redhat.com>:
> Thanks!  That's pretty much what I wanted...  The one thing that's missing is
> the ability to give this to C-x b, but I suppose C-x f will have to do.

Not sure I understand -- it actually changes the name of the buffers,
so C-x b should see the names too...
(by default it retroactively renames existing buffers to reflect
needed "uniquification" too)

-Miles

-- 
Do not taunt Happy Fun Ball.

