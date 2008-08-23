Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYHWG5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYHWG5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 02:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYHWG44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 02:56:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:59460 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYHWG4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 02:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ve7miroFz4SNby8cL53gyEZwh2hrfbg6JYOSmCxR/VIchm+MutgPoICEASLssHEsNL
         65osiPYZ816pjajX8rQKoBa0p972ZpZk84PInZT6Dxn28Kvf9+lXEViD9hwQB3tUAAsR
         T2Kuen3n4dwWfP1lfDFnyJtR25KBkMq458H3k=
Message-ID: <86802c440808222356r716fe370v49519486ae74aa30@mail.gmail.com>
Date: Fri, 22 Aug 2008 23:56:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>, "Vivek Goyal" <vgoyal@redhat.com>,
       "Bill Fink" <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <86802c440808222241k36c95cd2h8e24031be1dc7b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <773466.71707.qm@web82102.mail.mud.yahoo.com>
	 <86802c440808222241k36c95cd2h8e24031be1dc7b8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please send out after booting with hpet=disable
lspci -tv
lspci -vvxxx

YH
