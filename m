Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbZLFVEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbZLFVEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbZLFVEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:04:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683AbZLFVEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:04:51 -0500
Message-ID: <4B1C1C6A.8070209@redhat.com>
Date: Sun, 06 Dec 2009 16:04:42 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Larry Woodman <lwoodman@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC] high system time & lock contention running large mixed
 workload
References: <20091125133752.2683c3e4@bree.surriel.com>	 <1259618429.2345.3.camel@dhcp-100-19-198.bos.redhat.com>	 <20091201102645.5C0A.A69D9226@jp.fujitsu.com>	 <1259685662.2345.11.camel@dhcp-100-19-198.bos.redhat.com>	 <4B15CEE0.2030503@redhat.com>	 <1259878496.2345.57.camel@dhcp-100-19-198.bos.redhat.com>	 <4B1857ED.30304@redhat.com> <1259962013.3221.8.camel@dhcp-100-19-198.bos.redhat.com>
In-Reply-To: <1259962013.3221.8.camel@dhcp-100-19-198.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 04:26 PM, Larry Woodman wrote:

>
> Here it is:

Kosaki's patch series looks a lot more complete.

Does Kosaki's patch series resolve your issue?

-- 
All rights reversed.
