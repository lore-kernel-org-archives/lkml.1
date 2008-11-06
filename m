Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYKFPk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYKFPk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYKFPkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:40:15 -0500
Received: from n67.bullet.mail.sp1.yahoo.com ([98.136.44.47]:47167 "HELO
	n67.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752367AbYKFPkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:40:13 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 143223.79281.bm@omp403.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=J5rfChVZbcjGRceyZ7CdVUcnLAuP3qYtQlegzXgikEnHAsJ181KVIO2/IC30y2SWVhsE+Q+sSxMaVO+7h/LXSgIY6bfVciLALQQjP/iS6b1KuEx+8MzgHLEn+YL0av6ltX25C5eJezhBFYzUDNdfa9YBTQpWSm7hwR02pVqNXx0=;
X-YMail-OSG: KC7O.PcVM1k6DYw8wsfscceK0bWfc_S7amfouv072Ehpyb12S.ZA_L3IswU7Ja99wfskOnwr1RXz8zUDkMCP0Rn4MWqq6YX4cJ0VJ.mqboFqF.15_AnY.qitW1Z7H9rqfkRnaCJhMKFj2FO4esdF6dvzkamv
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 6 Nov 2008 07:40:12 -0800 (PST)
From: H L <swdevyid@yahoo.com>
Reply-To: swdevyid@yahoo.com
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
To: Yu Zhao <yu.zhao@intel.com>, Greg KH <greg@kroah.com>
Cc: randy.dunlap@oracle.com, grundler@parisc-linux.org, achiang@hp.com,
       matthew@wil.cx, linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20081106044828.GA30417@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <909674.99469.qm@web45112.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greetings (from a new lurker to the list),

To your question Greg, "yes" and "sort of" ;-).  I have started taking a look at these patches with a strong interest in understanding how they work.  I've built a kernel with them and tried out a few things with real SR-IOV hardware.

--
Lance Hartmann




--- On Wed, 11/5/08, Greg KH <greg@kroah.com> wrote:
> 
> Is there any actual users of this API around yet?  How was
> it tested as
> there is no hardware to test on?  Which drivers are going
> to have to be
> rewritten to take advantage of this new interface?
> 
> thanks,
> 
> greg k-h
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization


      

