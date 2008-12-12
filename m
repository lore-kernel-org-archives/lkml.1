Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYLMGVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYLMGVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 01:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbYLMGVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 01:21:01 -0500
Received: from blaine.gmane.org ([80.91.229.8]:39532 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbYLMGVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 01:21:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wpSo9EgXj5hSGbSRIreONolWU8ArUIruVyq4uE+XXUSmiXW9z1Y3242J/NzZJNJF3e
         VgxVCeaqHMyMfI4imgG3VzwxeXRjHLnvkWSM7qHcvPXDZEAu72wfGieTKfA8vIzPC8Tj
         rG4IGgHF+Od5Vm9PCmdp1GqUvtkbXDqb1bBvo=
Message-ID: <c072ca310812120339p323ece11r4ba26fd3731f459a@mail.gmail.com>
Date: Fri, 12 Dec 2008 16:39:28 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: "Zdenek Kabelac" <zkabelac@redhat.com>
Subject: Re: iwlagn interrupt problem
Cc: "reinette chatre" 
	<public-reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@hugh.gmane.org>,
       "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       "linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" 
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
In-Reply-To: <49424B7A.9060700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c072ca310812100638k6c15473brb89632a9c175a028@mail.gmail.com>
	 <c072ca310812100710o58c38a27rba16ad2318a1cb95@mail.gmail.com>
	 <1228929548.18730.21.camel@rc-desk>
	 <c072ca310812110548s64612ac7icd6e9187aa4af75a@mail.gmail.com>
	 <49424419.1090103@redhat.com>
	 <c072ca310812120323r2c92420di5a138ae6265d567f@mail.gmail.com>
	 <49424B7A.9060700@redhat.com>
X-TMDA-Confirmed: Sat, 13 Dec 2008 07:20:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




2008/12/12 Zdenek Kabelac <zkabelac@redhat.com>:
> Should I open new bugzilla separately ?

Try it. In the worst case, your report will be closed as a duplicate
of something else :)

-- 
Alexander E. Patrakov


