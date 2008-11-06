Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbYKFT6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbYKFT6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYKFT62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:58:28 -0500
Received: from n66.bullet.mail.sp1.yahoo.com ([98.136.44.50]:23651 "HELO
	n66.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751007AbYKFT61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:58:27 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 312672.54341.bm@omp403.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=FBnuS7DoIwzwn4chbm/laIZ/QKRgcV/ODsaOXJ/l5Ntpfr9L/cYxeVFz5i+HEtNi9VZIGFJYEusyGhqhpbK5xK9tF3ij7BB+LpNYZSAR4H45viXyzTeZdMTwtVRqP3ezZGDHTpcZ5gDfdMUjE/C10wPTOyguxmEzTRMJ/XM2o54=;
X-YMail-OSG: nBqyL4wVM1lNoMMufSZnErXwyknbYnPENPeLNqsbTdvcQvRM8M0FaRUY69r30RIb_xKf1TZYfcm8dTTJuoEG8CL_N523Ma_qRiEb61n3u.mYMvZw.lc0FVj0rMA1_DF3ojt7CvvBC5WVVxU7wAzQZiupYkKB
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 6 Nov 2008 11:58:25 -0800 (PST)
From: H L <swdevyid@yahoo.com>
Reply-To: swdevyid@yahoo.com
Subject: Re: git repository for SR-IOV development?
To: Greg KH <greg@kroah.com>
Cc: Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu, Xen-devel List <xen-devel@lists.xensource.com>
In-Reply-To: <20081106165914.GA13476@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <104014.9320.qm@web45110.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 11/6/08, Greg KH <greg@kroah.com> wrote:

> On Thu, Nov 06, 2008 at 08:51:09AM -0800, H L wrote:
> > 
> > Has anyone initiated or given consideration to the
> creation of a git
> > repository (say, on kernel.org) for SR-IOV
> development?
> 
> Why?  It's only a few patches, right?  Why would it
> need a whole new git
> tree?


So as to minimize the time and effort patching a kernel, especially if the tree (and/or hash level) against which the patches were created fails to be specified on a mailing-list.  Plus, there appears to be questions raised on how, precisely, the implementation should ultimately be modeled and especially given that, who knows at this point what number of patches will ultimately be submitted?  I know I've built the "7-patch" one (painfully, by the way), and I'm aware there's another 15-patch set out there which I've not yet examined.



      

